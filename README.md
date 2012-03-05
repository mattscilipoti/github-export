GitHub Exporter
===============

A library to help you export your data from GitHub.

Utilizes GitHub's API V3.

Supports:
* Issues 

Usage
-----

Export to dir (creates a file per issue):

    your_repo_uri = 'https://api.github.com/repos/user_name/repo_name'
    GHE::Issues.new(your_repo_uri, :user => 'username', :password => 'PASS').to_dir(dir_to_export_to)


GHE::Issues.new(base_api_repo_url) acts as an array of hashes.  It is enumerable.


Considerations
--------------

Frustrated by continual use of Hash.fetch('key').  Thinking of creating method for each key.

