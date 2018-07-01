# PHP Unit Tests for WordPress on Windows

## Introduction

Since I didn't find any useful scripts for executing PHP Unit Tests for my WordPress plugins on my Windows development environment without using the Windows 10 Linux subsystems etc., I figured it would make sense to write my own PowerShell script.

## Synopsis

With the script at hand, it is possible to execute php unit tests for WordPress locally on a Windows workstation, assuming that your plugin is available on GitHub (if not, you probably would need to tweak the script). This should save you some time compared to uploading it e.g. to travis.ci. The script helps automating the steps that are normally executed using WP-CLI such as **scaffold plugin-tests** and **bin/install-wp-tests.sh**. But WP-CLI scripts require a Linux subsystem on Windows 10, which I at least consider a bit of a stretch. Hence I came up with the following solution.

### One time plugin project configuration

Manually update your plugin project to:

1. Include all the files needed to for the unit test execution environment's scaffold e.g. bootstrap file(s), phpunit configuration file(s) etc. and provide these file as part from (this) project so that they need little or no tweaking
2. Write unit tests and save them to the plugin's repository
3. Commit the changes

### Automated unit test execution environment setup

Then use the script to:

1. Create a working directory
2. Clone the plugin into the working directory
3. Run composer to install all of the plugin's dependencies and as well as installing phpunit
4. Download the phpunit folder from the wordpress/wordpress-develop/trunk/tests folder
5. Install a fresh copy of WordPress using [Bedrock](https://roots.io/bedrock/)
6. Create a new MySql database for the fresh WordPress instance
7. Run the unit tests

After running the script (with parameter -Setup set to $true), the plugin's folder structure inside the working directory will look as follows (assuming that you created a working directory called **plugin.unittest** and want to test a plugin with **wpo365-login** as slug):

```code
+ [plugin.unittest] --> working directory
+--  [wpo365-login] --> folder for the plugin to be unit tested
|    +-- [tests] --> folder to hold all test related artefacts, some temporary but others from the repository
|        +-- [phpunit] --> phpunit test folder from wordpress-develop
|        +-- [wp] --> fresh wp installation created with Bedrock
|        +-- [vendor] --> composer's vendor file
|        +-- composer.json --> an "extra" composer.json file to load phpunit as a developer dependency
|        +-- bootstrap.php --> an "extra" bootstrap file to set WordPress / PHP globals
|        +-- phpunit.xml --> phpunit configuration
|        +-- wp-test-config.php --> a "special" phpunit optimized wp-config.php file for the WordPress instance
|        +-- test-sample-unit-test.php -->a sample WordPress phpunit test case
|    +-- other plugin folder(s) and file(s)
```

## Getting started

### Prerequisites

1. [Composer dependency management for PHP](https://getcomposer.org/)
2. [git (for Windows)](https://git-scm.com/download/win)
3. [mysql e.g. as part of WAMP](http://www.wampserver.com/en/)
4. Make sure that your PATH environment variable can find PHP, composer, git, mysql etc. On my local machine, I needed to add the following entries manually:

* PHP.exe --> C:\wamp\bin\php\php7.0.23
* Composer --> C:\Users\mvwie\AppData\Roaming\Composer\vendor\bin
* MySql --> C:\Users\mvwie\AppData\Roaming\Composer\vendor\bin

### Important

PHP and WordPress that you use may require you to change the required version of PHPUnit as listed in [composer.json](sample-files/composer.json). At this moment (Juli 2018) WordPress is capable of dealing with version PHPUnit 6.5, which is not the latest.

### One time plugin project configuration

1. Add a folder called **tests** to your plugin's project
2. Download and add [composer.json](sample-files/composer.json) to the **tests** folder
3. Download and add [bootstrap.php](sample-files/bootstrap.php) to the **tests** folder
4. Download and add [phpunit.xml](sample-files/phpunit.xml) to the **tests** folder
5. Download and add [wp-tests-config.php](sample-files/wp-tests-config.php) to the **tests** folder
6. (Optionally) Update the database settings on line 35-38 **tests\wp-tests-config.php**
7. Download and add [test-my-unit-test.php](sample-files/test-my-unit-test.php) to the **tests** folder
8. Commit changes
9. Clone this project to your local machine
10. Update winwpunit.jsonf

### Automated unit test execution environment setup

1. Run **WinWpUnit.ps1 -Setup $true**
2. To run the unit tests again, run **WinWpUnit.ps1 -Setup $false**