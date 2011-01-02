require 'webrobots/robotstxt'
require 'uri'
require 'net/https'

class WebRobots
  # Creates a WebRobots object for a robot named +user_agent+, with
  # optional +options+.
  #
  # * :http_get => a custom method, proc, or anything that responds to
  #   .call(uri), to be used for fetching robots.txt.  It must return
  #   the response body if successful, or raise Net::HTTPNotFound if
  #   the resource is not found.  Any other errror is regarded as
  #   blanket ban.
  def initialize(user_agent, options = nil)
    @user_agent = user_agent
    @parser = RobotsTxt::Parser.new(user_agent)

    options ||= {}
    @http_get = options[:http_get] || method(:http_get)

    @robotstxt = {}
  end

  # Returns the robot name initially given.
  attr_reader :user_agent

  # Tests if the robot is allowed to access a resource at +url+.  If a
  # malformed URI string is given, URI::InvalidURIError is raised.  If
  # a relative URI or a non-HTTP/HTTPS URI is given, ArgumentError is
  # raised.
  def allowed?(url)
    site, request_uri = split_uri(url)
    return true if request_uri == '/robots.txt'
    robots_txt(site).allow?(request_uri)
  end

  # Equivalent to !allowed?(url).
  def disallowed?(url)
    !allowed?(url)
  end

  # Returns extended option values for a resource at +url+ in a hash
  # with each field name lower-cased.  See allowed?() for a list of
  # errors that may be raised.
  def options(url)
    site, = split_uri(url)
    robots_txt(site).options
  end

  # Equivalent to option(url)[token.downcase].
  def option(url, token)
    options(url)[token.downcase]
  end

  # Returns an array of Sitemap URLs.  See allowed?() for a list of
  # errors that may be raised.
  def sitemaps(url)
    site, = split_uri(url)
    robots_txt(site).sitemaps
  end

  private

  def split_uri(url)
    site =
      if url.is_a?(URI)
        url.dup
      else
        begin
          URI.parse(url)
        rescue => e
          raise ArgumentError, e.message
        end
      end

    site.scheme && site.host or
      raise ArgumentError, "non-absolute URI: #{url}"

    site.is_a?(URI::HTTP) or
      raise ArgumentError, "non-HTTP/HTTPS URI: #{url}"

    request_uri = site.request_uri
    if (host = site.host).match(/[[:upper:]]/)
      site.host = host.downcase
    end
    site.path = '/'
    return site, request_uri
  end

  def robots_txt(site)
    cache_robots_txt(site) {
      fetch_robots_txt(site)
    }
  end

  def fetch_robots_txt(site)
    begin
      body = @http_get.call(site + 'robots.txt')
    rescue Net::HTTPNotFound
      return ''
    end
    @parser.parse(body, site)
  end

  def cache_robots_txt(site, &block)
    if @robotstxt.key?(site)
      @robotstxt[site]
    else
      @robotstxt[site] = block.call(site)
    end
  end

  def http_get(uri)
    referer = nil
    10.times {
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.is_a?(URI::HTTPS)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      header = { 'User-Agent' => @user_agent }
      header['Referer'] = referer if referer
      # header is destroyed by this in ruby 1.9.2!
      response = http.get(uri.request_uri, header)
      case response
      when Net::HTTPSuccess
        return response.body
      when Net::HTTPRedirection
        referer = uri.to_s
        uri = URI(response['location'])
      else
        response.value
      end
    }
    raise 'too many HTTP redirects'
  end
end
