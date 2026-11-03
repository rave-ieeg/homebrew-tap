cask "rave-ieeg" do
  version "1.0.74,d94b68c6d88e4503aeed695c5bd1e88710c4676c"
  sha256 "d72037009dc3fd39b91ed696aa0e3bd924a8f710c77fd1c0253d4a6b264e69ee"

  url "https://raw.githubusercontent.com/dipterix/ravemanager/#{version.csv.second}/inst/shell/rave",
      verified: "raw.githubusercontent.com/dipterix/ravemanager/"
  name "RAVE"
  desc "Reproducible Analysis and Visualization of intracranial EEG data"
  homepage "https://rave.wiki/"

  livecheck do
    skip "Pinned by hand"
  end

  # `rave` checks the version of an existing R
  depends_on cask: "r-app" unless File.executable?("/Library/Frameworks/R.framework/Resources/bin/Rscript")
  depends_on formula: %w[cmake fftw hdf5 jpeg libgit2 libpng libtiff libxml2 node pkgconf]

  installer script: {
    executable:   "/bin/bash",
    args:         ["#{staged_path}/rave", "update"],
    must_succeed: false,
  }

  # Runs before the installer, so `rave` exists even if the install is interrupted
  preflight_steps do
    write_file "rave-wrapper", <<~SH
      #!/bin/bash
      exec /bin/bash "{{staged_path}}/rave" "$@"
    SH
    set_permissions "rave-wrapper", "0755"
    symlink "rave-wrapper", "bin/rave", target_base: :homebrew_prefix, overwrite: true, remove_on_uninstall: true
  end

  # Only what RAVE can download again. Never add rave_data, settings or templates.
  zap trash: [
    "~/Library/Caches/org.R-project.R/R/dipsaus",
    "~/Library/Caches/org.R-project.R/R/ravemanager",
    "~/Library/Caches/org.R-project.R/R/readNSx",
    "~/Library/r-rpymat",
  ]

  caveats <<~EOS
    Start RAVE with:
      rave start
    If the install above didn't finish, that command finishes it.

    Some modules need Python. Set it up with:
      rave configure python
  EOS
end
