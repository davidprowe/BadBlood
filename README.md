BadBlood
========
BadBlood by Secframe fills a Microsoft Active Directory Domain with a structure and thousands of objects. The output of the tool is a domain similar to a domain in the real world.  After BadBlood is ran on a domain, security analysts and engineers can practice using tools to gain an understanding and prescribe to securing Active Directory. Each time this tool runs, it produces different results.  The domain, users, groups, computers and permissions are different. Every. Single. Time.

- [Full User Guide and Info](https://www.secframe.com/badblood/)

<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/BadBlood%20Icon.png" width=50% alt="BadBlood Icon">

# Commands

- `NONE`: At this time all items of the script are configured in the .ps1 files.  Files are outlined on the User Guide on [Secframe.com](https://www.secframe.com)


## Acknowledgments

I'd like to thanks the countless people who wanted this as a product and waited while I made it!


# Screenshots

<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/BadBlood%20Intro.png" width=100% alt="BadBlood Intro">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood1.png" alt="badblood start screen">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/Every%20Single%20Time.png" alt="BadBlood Every Single Time">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood2.png" alt="Findings">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood4.png" alt="IAM report">



## Installation

Requirements:
- Domain Admin and Schema Admin permissions
- Active Directory Powershell Installed

Running On Windows:
```
# clone the repo
git clone https://github.com/davidprowe/badblood.git
#Run Invoke-badblood.ps1
./badblood/invoke-badblood.ps1
```

# Talk About the BadBlood

1. Message or Follow me on twitter @ davidprowe
2. Drop a note on secframe.com

## License
This project is licensed under the gplv3 License - see the LICENSE.md file for details


