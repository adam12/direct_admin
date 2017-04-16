module DirectAdmin
  module Commands
    def create_login_key(name, value, options = {})
      never_expires = options.fetch(:never_expires, false)
      expiration = options[:expiration]
      allow_htm = options.fetch(:allow_htm, true)
      allowed_commands = options.fetch(:allowed_commands, [])
      allowed_ips = options.fetch(:allowed_ips, []).join("\r\n")
      max_uses = options.fetch(:max_uses, 1)
      clear_key = options.fetch(:clear_key, false)

      params = {
        "keyname" => name,
        "key" => value,
        "key2" => value,
        "never_expires" => never_expires,
        "max_uses" => max_uses,
        "ips" => allowed_ips,
        "passwd" => server_password,
        "create" => "Create"
      }

      params["never_expires"] = "yes" if never_expires
      params["clear_key"] = "yes" if clear_key
      params["allow_htm"] = "yes" if allow_htm

      if !never_expires && expiration
        params["hour"] = expiration.hour
        params["minute"] = expiration.minute
        params["month"] = expiration.month
        params["day"] = expiration.day
        params["year"] = expiration.year
      end

      allowed_commands.each_with_index do |command, i|
        params["select_allow#{i}"] = command
      end

      request(:post, "/CMD_API_LOGIN_KEYS", params)
    end
  end
end
