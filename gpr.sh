if [ $? -eq 0]; 
    then
        github_url=$(git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git:://)#http://#' -e 's@com:@com/@' -e 's%\.git$%%');
        branch_name=$(git symbolic-ref HEAD 2>/dev/null);
        clean_remote_branch=${branch_name#refs/heads/*}
        pr_url=$($github_url"/compare/master..."$branch_name);
        open $pr_url
    else
        echo 'Failed to open a pull request.'
    fi