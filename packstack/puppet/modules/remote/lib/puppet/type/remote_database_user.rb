
Puppet::Type.newtype(:remote_database_user) do
  @doc = "Manage a database user remotely. This includes management of users password as well as priveleges"

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The name of the user. This uses the 'username@hostname' or username@hostname."
    validate do |value|
      # https://dev.mysql.com/doc/refman/5.1/en/account-names.html
      # Regex should problably be more like this: /^[`'"]?[^`'"]*[`'"]?@[`'"]?[\w%\.]+[`'"]?$/
      raise(ArgumentError, "Invalid database user #{value}") unless value =~ /[\w-]*@[\w%\.:]+/
      username = value.split('@')[0]
      if username.size > 16
        raise ArgumentError, "MariaDB usernames are limited to a maximum of 16 characters"
      end
    end
  end

  newproperty(:password_hash) do
    desc "The password hash of the user. Use mysql_password() for creating such a hash."
    newvalue(/\w+/)
  end

  newparam(:db_host) do
    desc "The hostname of the database server to connect."
  end

  newparam(:db_user) do
    desc "The user name to use when connecting to the server."
  end

  newparam(:db_password) do
    desc "The password with which to connect to the database server."
  end

end
