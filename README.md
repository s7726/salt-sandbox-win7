salt-sandbox-win7
-----------------

Working salt sandbox including a win7 minion

  - Precise64 master with minion (salt)
  - Precise64 minion (minion1)
  - Windows7 minion (minion2)

The win7 minion's actual hostname is vagrant-win7, but the host files
are all setup such that it responds to minion2. FQDNs for the boxes
append 'example.com' to each of the given hostnames.
Vagrant should be setting the windows hostname and domain but isn't.

Windows Minion Version
======================
At the moment (2014-08-22), the default bootstrap script used by Vagrant for
Windows minions is hard-coded to use salt minion version 2014.1.3-1, which
is out of date. In order to automatically provision the Windows minion with
a more recent minion, it is necessary to modify Vagrant's salt bootstrap
script, which can be found at
`<vagrant install directory>\embedded\gems\gems\vagrant-<version>\plugins\provisioners\salt\bootstrap-salt.ps1`

This Powershell script contains a line specifying where to download the minion
installer from, in the form `$url = "https://docs.saltstack.com/downloads/..."`.
Modifying this line to indicate the correct desired version sould solve the
problem. For example, at the time of this writing, the current version of the
salt minion is 2014.1.10, meaning that this line should be modified to read
`$url = "https://docs.saltstack.com/downloads/Salt-Minion-2014.1.10-$arch-Setup.exe"`

Windows Minion First Boot
=========================
By default, the Windows box is configured to start with the GUI shown. This is
so that several issues in the box may be taken care of after the first boot.

At the time of this writing (2014-08-22), the Windows box used is somewhat out
of date, resulting in expired passwords and missing Windows updates. As a
result, upon the first boot, it will complain that the `vagrant` user's password
has expired and must be reset. In order for Vagrant to be able to access the
box correctly, the new password must be `vagrant`, as it is with all other
Vagrant boxes. Just give Windows the same password again, and it will be happy
again.

You should also plan on running Windows Update against the box to apply all the
recent patches from Microsoft, thus ensuring that the Windows box is more
closely representative of a real environment.

Additionally, it will complain about being unable to reconnect a shared network
drive. Feel free to disconnect this mapped drive if it bugs you, as it is not
used in this sandbox.
