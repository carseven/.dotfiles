if [ $? -eq 0]; 
    then
        github_url=$(git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git:://)#http://#' -e 's@com:@com/@' -e 's%\.git$%%');
        echo $github_url
        branch_name=$(git symbolic-ref HEAD 2>/dev/null);
        echo $branch_name
        clean_remote_branch=${branch_name#refs/heads/*}
        echo $clean_remote_branch
        pr_url=$($github_url"/compare/master..."$branch_name);
        echo $pr_url
        open $pr_url
    else
        echo 'Failed to open a pull request.'
    fi