if [ $? -eq 0]; then
        # origin  https://github.com/carseven/.dotfiles.git (fetch) -> https://github.com/carseven/.dotfiles.git
        github_url=$(git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git:://)#http://#' -e 's@com:@com/@' -e 's%\.git$%%');
        branch_name=`feature/$(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)`
        pr_url=$($github_url"/comapare/master..."$branch_name)
        echo '${pr_url}'
        open $pr_url
    else
        echo 'Failed to open a pull request.'
    fi