require 'capistrano/git'

class Capistrano::Git
  module SubmoduleStrategy
    # do all the things a normal capistrano git session would do
    include Capistrano::Git::DefaultStrategy

    # put the working tree in a release-branch,
    # make sure the submodules are up-to-date
    # and copy everything to the release path
    def release
      temp_path = File.join(fetch(:tmp_dir), 'repo')
      context.execute("rm -Rf #{temp_path}")
      git :clone, '--depth=1', '--recursive', '-b', fetch(:branch), "file://#{repo_path}", temp_path
      context.execute("find #{temp_path} -name '.git*' | xargs -I {} rm -rfv {}")
      context.execute("cp -R #{temp_path}/. #{release_path}/")
    end
  end
end
