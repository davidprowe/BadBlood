BadBlood
========
BadBlood by Secframe fills a Microsoft Active Directory Domain with a structure and thousands of objects. The output of the tool is a domain similar to a domain in the real world.  After BadBlood is ran on a domain, security analysts and engineers can practice using tools to gain an understanding and prescribe to securing Active Directory. Each time this tool runs, it produces different results.  The domain, users, groups, computers and permissions are different. Every. Single. Time.

- [Full User Guide and Info](https://www.secframe.com/badblood/)

<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/BadBlood%20Icon.png" width=50% alt="BadBlood Icon">

# Commands

- `NONE`: At this time all items of the script are configured in the .ps1 files.  Files are outlined on the User Guide on [Secframe.com](https://www.secframe.com/badblood/)


## Acknowledgments

I'd like to send thanks to the countless people who wanted this as a product and waited while I made it!


# Screenshots

<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/BadBlood%20Intro.png" width=100% alt="BadBlood Intro">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood1.png" alt="badblood start screen">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood2.png" alt="Findings">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood4.png" alt="IAM report">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/Every%20Single%20Time.png" alt="BadBlood Every Single Time">
<img src="https://cdn2.hubspot.net/hubfs/3896789/SecFrame/BadBlood/badblood5_bloodhoundimport.png" alt="Sample Bloodhound Sample After Badblood">



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
3. I am not responsible for cleanup if this is run in a production domain

## License
This project is licensed under the gplv3 License - see the LICENSE.md file for details

## Disclaimer
Please note: all tools/ scripts in this repo are released for use "AS IS" without any warranties of any kind, including, but not limited to their installation, use, or performance. We disclaim any and all warranties, either express or implied, including but not limited to any warranty of noninfringement, merchantability, and/ or fitness for a particular purpose. We do not warrant that the technology will meet your requirements, that the operation thereof will be uninterrupted or error-free, or that any errors will be corrected.

Any use of these scripts and tools is at your own risk. There is no guarantee that they have been through thorough testing in a comparable environment and we are not responsible for any damage or data loss or time loss incurred with their use.

You are responsible for reviewing and testing any scripts you run thoroughly before use in any non-testing environment.  This tool is not designed for a production environment.


