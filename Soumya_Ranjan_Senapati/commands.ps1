$cmds = @(
"git status",
"git branch -vv",
"git diff --name-only --diff-filter=U",
"git log --graph --oneline --decorate --all --max-count=50",
"git log origin/main..HEAD --oneline",
"git log HEAD..origin/main --oneline",
"git log --left-right --graph HEAD...origin/main --oneline",
"git reflog --date=local -20",
"git stash list",
"git remote -v",
"git rev-parse HEAD",
"git rev-parse origin/main"
)

foreach ($c in $cmds) {
    Write-Host ""
    Write-Host "==============================="
    Write-Host $c
    Write-Host "==============================="
    Invoke-Expression $c
}


