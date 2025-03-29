# Ansible Cheat Sheet & Fixes

## Unsupported Locale

After installing Ansible, you may see this error:

``` log
ERROR: Ansible could not initialize the preferred locale: unsupported local setting
```

Update you locales like so:

``` bash
export LC_ALL="en_US.utf8"
export LC_CTYPE="en_US.utf8"
sudo dpkg-reconfigure locales
```

Some systems may prefer `en_US.UTF-8`, but my Ubuntu WSL uses `utf8` by default.

Check you locales with the `locale` command.

Source: https://stackoverflow.com/a/36257050

## How to run Ansible Galaxy

``` bash
ansible-galaxy install --force -r requirements.yml

ansible-playbook main.yml -u $network_user --ask-pass --ask-become-pass
```
