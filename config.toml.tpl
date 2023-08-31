baseurl = "https://ahaooahaz.github.io/"  # Include trailing slash
title = "AH.OI"
# this example loads the theme as hugo module
# comment out line below, and uncomment the line after it if you prefer to load the theme normally
theme = ["github.com/ahaooahaz/newsroom"] # edit this if you'ld rather use a fork of this repo
# theme = "newsroom"
author = "ahaooahaz"
canonifyurls = true
paginate = 9

[markup]
  [markup.goldmark.renderer]
    hardWraps = false
    unsafe = false # change to true to enable inclusion of rawHTML and math functions
    xhtml = false
  [markup.highlight]
    codeFences = true
    guessSyntax = false
    hl_Lines = ""
    lineNoStart = 1
    lineNos = true
    lineNumbersInTable = false
    noClasses = true
    tabWidth = 4

# If you want to use disqus, uncomment the line below
# disqusShortname = "yourdiscussshortname"

# ids used below are not valid. Replace with valid ones
[params]
  locale = "en_US"
  ga_analytics = "$GOOGLE_ANALYTICS" # google analytics ID e.g UA-116386578-1
  # ga_verify = "" # google verification code e.g 5jb-rxeBfITeJQKOuUss3ud6FPGTxXkCho-ZN5qlrZg
  # twitter = "" # twitter handle e.g @weru
  # mainSections = ["blog"] # see https://gohugo.io/functions/where/#mainsections
  # uncomment the line below will disable darkmode by default.
  # uncomment and set value below to either "light" or "dark" to make default mode dark.
  defaultMode = "light" # Note that the UI control for toggling darkmode will remain in place. This way, the user can decide which mode they would like to use while browsing your website
  logo = "" # if the value is an empty string, the site title will be shown instead
  faviconsDir = "images/icons/" # with a trailing slash
  blogDir = "post" # edit
  enableGitalk = true

[params.gitalk] 
    clientID = "$GITALK_CLIENT_ID" # Your client ID
    clientSecret = "$GITALK_CLIENT_SECRET" # Your client secret
    repo = "ahaooahaz.github.io" # The repo to store comments
    owner = "ahaooahaz" # Your GitHub ID
    admin= "ahaooahaz" # Required. GitHub repository owner and collaborators. (Users who having write access to this repository)
    id= "$GITALK_ID" # The unique id of the page.
    labels= "gitalk" # GitHub issue labels. If you used to use Gitment, you can change it
    perPage= 15 # Pagination size, with maximum 100.
    pagerDirection= "last" # Comment sorting direction, available values are 'last' and 'first'.
    createIssueManually= false # If it is 'false', it is auto to make a GitHub issue when the administrators login.
    distractionFreeMode= false # Enable hot key (cmd|ctrl + enter) submit comment.
