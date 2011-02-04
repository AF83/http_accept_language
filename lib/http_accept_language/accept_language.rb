module HttpAcceptLanguage
  module AcceptLanguage
    # Returns a sorted array based on user preference in HTTP_ACCEPT_LANGUAGE.
    # Browsers send this HTTP header, so don't think this is holy.
    #
    # Example:
    #
    #   request.user_preferred_languages
    #   # => [ 'nl-NL', 'nl-BE', 'nl', 'en-US', 'en' ]
    #
    def user_preferred_languages
      @user_preferred_languages ||= env['HTTP_ACCEPT_LANGUAGE'].split(/\s*,\s*/).collect {|l|
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
      }.select {|l|
        l.first =~ /^[a-z\-]+$/i
      }.sort { |x,y|
        y.last.to_f <=> x.last.to_f
      }.collect { |l|
        l.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
      }
    rescue # Just rescue anything if the browser messed up badly.
      []
    end

    # Sets the user languages preference, overiding the browser
    #
    def user_preferred_languages=(languages)
      @user_preferred_languages = languages
    end

    # Finds the locale specifically requested by the browser.
    #
    # Example:
    #
    #   request.preferred_language_from I18n.available_locales
    #   # => 'nl'
    #
    def preferred_language_from(array)
      (user_preferred_languages & array.collect { |i| i.to_s }).first
    end

    # Returns the first of the user_preferred_languages that is compatible
    # with the available locales. Ignores region.
    #
    # Example:
    #
    #   request.compatible_language_from I18n.available_locales
    #
    def compatible_language_from(available_languages)
      user_preferred_languages.map do |x| #en-US
        available_languages.find do |y| # en
          y = y.to_s
          x == y || x.split('-', 2).first == y.split('-', 2).first
        end
      end.compact.first
    end

  end
end
