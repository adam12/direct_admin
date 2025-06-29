# frozen_string_literal: true

require "oga"

module DirectAdmin
  module Commands
    # Create a login key
    #
    #   client.create_login_key("CLI Tool", "abcd1234")
    #
    # == Required Arguments
    #
    # :name :: The name of the login key
    # :value :: The value of the login key
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

    # Verify the username and password of a user
    #
    #   client.verify_password("admin", "secret")
    def verify_password(username, password)
      params = {
        "user" => username,
        "passwd" => password
      }

      response = request(:post, "/CMD_API_VERIFY_PASSWORD", params)

      if response.has_key?("valid")
        Integer(response["valid"]) == 1
      end
    end

    # Authenticate email account. Must be logged in as domain owner for command
    # to be successful.
    #
    #   client.email_auth("user@domain.com", "secret")
    def email_auth(email, password)
      params = {
        "email" => email,
        "passwd" => password
      }

      response = request(:post, "/CMD_API_EMAIL_AUTH", params)

      if response.has_key?("error")
        Integer(response["error"]) == 0
      end
    end

    # Owner of domain
    #
    #   client.domain_owner("domain.com")
    def domain_owner(domain)
      params = {
        "domain" => domain
      }

      response = request(:post, "/CMD_API_DOMAIN_OWNERS", params)

      if response.has_key?(domain)
        response[domain]
      end
    end

    # Email Account information
    #
    #   client.email_account_quota(email_address: "user@example.com", password: "secret")
    def email_account_quota(email_address:, password:)
      username, domain = email_address.split("@", 2)

      params = {
        "domain" => domain,
        "user" => username,
        "password" => password,
        "api" => 1,
        "quota" => "yes"
      }

      request(:post, "/CMD_EMAIL_ACCOUNT_QUOTA", params, authenticate: false).tap { |response|
        response.delete("error")

        integer_fields = %w(
          imap imap_bytes inbox inbox_bytes spam spam_bytes
          total total_bytes webmail webmail_bytes
        )

        integer_fields.each do |key|
          response[key] = Integer(response[key])
        end
      }
    end

    # Get Account vacation message
    def get_account_vacation_message(email_address:, password:)
      username, domain = email_address.split("@", 2)

      params = {
        "domain" => domain,
        "user" => username,
        "password" => password,
        "api" => 1
      }

      request(:post, "/CMD_EMAIL_ACCOUNT_VACATION", params).tap { |response|
        response["reply_content_type"] = Oga.parse_html(response.delete("reply_content_types")).at_css("[selected]").then {|node|
          [node.get("value"), node.text]
        }

        response["reply_encoding"] = Oga.parse_html(response.delete("reply_encodings")).at_css("[selected]").then { |node|
          [node.get("value"), node.text]
        }

        response["reply_once"] = Oga.parse_html(response.delete("reply_once_select")).at_css("[selected]").then { |node|
          [node.get("value"), node.text]
        }
      }
    end
  end
end
