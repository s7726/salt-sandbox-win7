salt-sandbox-win7
=================

Working salt sandbox including a win7 minion

  - Precise64 master with minion (salt)
  - Precise64 minion (minion1)
  - Windows7 minion (minion2)

The win7 minion's actual hostname is vagrant-win7, but the host files
are all setup such that it responds to minion2. FQDNs for the boxes
append 'example.com' to each of the given hostnames.
Vagrant should be setting the windows hostname and domain but isn't.
