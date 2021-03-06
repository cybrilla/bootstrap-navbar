module BootstrapNavbar::Helpers
  def self.included(base)
    if BootstrapNavbar.configuration.bootstrap_version.nil?
      if Gem.loaded_specs.keys.include?('bootstrap-sass')
        bootstrap_sass_version = Gem.loaded_specs['bootstrap-sass'].version
        bootstrap_version = bootstrap_sass_version.segments.take(3).join('.')
        BootstrapNavbar.configuration.bootstrap_version = bootstrap_version
      else
        raise 'Bootstrap version is not configured.'
      end
    end
    helper_version = BootstrapNavbar.configuration.bootstrap_version[0]
    base.send :include, const_get("Bootstrap#{helper_version}")
  end

  def attributes_for_tag(hash)
    string = hash.map { |k, v| %(#{k}="#{v}") }.join(' ')
    if string.length > 0
      ' ' << string
    else
      string
    end
  end

  def current_url?(url)
    normalized_path, normalized_current_path = [url, current_url].map do |url|
      URI.parse(url).path.sub(%r(/\z), '') rescue nil
    end
    normalized_path == normalized_current_path
  end

  def current_url
    raise StandardError, 'current_url_method is not defined.' if BootstrapNavbar.configuration.current_url_method.nil?
    eval BootstrapNavbar.configuration.current_url_method
  end

  def prepare_html(html)
    html
  end
end
