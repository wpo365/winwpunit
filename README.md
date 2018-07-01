# PHP Unit Tests for WordPress on Windows

## Introduction

Since I didn't find any useful scripts for executing PHP Unit Tests for my WordPress plugins on my Windows development environment without using the Windows 10 Linux subsystems etc., I figured it would make sense to write my own PowerShell script.

## Synopsis

With the script at hand, it is possible to execute a continious integration kind-of workflow locally (to save time and cost). It fullfills (at least) the following requirements:

1. (Always) start from scratch i.e. with a fresh WordPress instance incl. database and latest plugin sources cloned from git
2. Unit tests and unit test configuration should be in the plugin's repo but anything else must be considered a dependency and not "contaminate" the repository
3. Run tests separately on an independent WordPress instance that is not the WordPress instance used for development
4. Start with nothing and then simply run a PowerShell script without any further copy/pasting/editing of files

And the workflow executes along the following steps when starting from scratch:

1. Add test artefacts such as bootstrap file(s), phpunit configuration file(s) and unit tests to the plugin's repository and commit
2. Create a working directory
3. Clone the plugin into the working directory
4. Run composer install to load all plugin (and plugin unit test) dependencies
5. Download phpunit folder from the wordpress/wordpress-develop/trunk/tests folder
6. Install a fresh copy of WordPress with [Bedrock](https://roots.io/bedrock/)
7. Create a new MySql database for the fresh WordPress instance
8. Run the unit tests

After running initial setup, the plugin's folder structure inside the working directory will look as follows (assuming that you created a working directory called **plugin.unittest** and want to test a plugin with **wpo365-login** as slug):

```code
+ [plugin.unittest] --> working directory
+--  [wpo365-login] --> folder for the plugin to be unit tested
|    +-- [tests] --> folder to hold all test related artefacts, some temporary but others from the repository
|       +-- [phpunit] --> phpunit test folder from wordpress-develop
|       +-- [wp] --> fresh wp installation created with Bedrock
|       +-- [vendor] --> composer's vendor file
|       +-- composer.json --> an "extra" composer.json file to load phpunit as a developer dependency
|       +-- bootstrap.php --> an "extra" bootstrap file to set WordPress / PHP globals
|       +-- phpunit.xml --> phpunit configuration
|       +-- wp-test-config.php --> a "special" phpunit optimized wp-config.php file for the WordPress instance
|       +-- test-sample-unit-test.php -->a sample WordPress phpunit test case
```

## Getting started

1. Add a folder called **tests** to your plugin's project
2. Add the following file to the **tests** folder: [composer.json](sample-files/composer.json)
3. Add the following file to the **tests** folder: [bootstrap.php](sample-files/bootstrap.php)
4. Add the following file to the **tests** folder: [phpunit.xml](sample-files/phpunit.xml)
5. Add the following file to the **tests** folder: [wp-tests-config.php](sample-files/wp-tests-config.php)
6. Add the following file to the **tests** folder: [test-my-unit-test.php](sample-files/test-my-unit-test.php)
7. Update the database settings on line 35-38 **tests\wp-tests-config.php**
8. Clone this project to your local machine
9. Update winwpunit.json
10. Run **WinWpUnit.ps1 -Setup $true**
11. To run the unit tests again, run **WinWpUnit.ps1 -Setup $false**