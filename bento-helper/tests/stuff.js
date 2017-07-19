
var DEFAULT_TIMEOUT=1000*5

module.exports = {
 'test case': function(client) {

     console.log(client)

     boxes = [
          "windows-nano-tp3"
          "ubuntu-17.04-i386",
          "ubuntu-17.04-amd64",
          "ubuntu-16.04-i386",
          "ubuntu-16.04-amd64",
          "ubuntu-14.04-i386",
          "ubuntu-14.04-amd64",
          "solaris-11-x86",
          "solaris-10.11-x86",
          "sles-12-sp2-x86_64",
          "rhel-7.3-x86_64",
          "rhel-6.9-x86_64",
          "rhel-6.9-i386",
          "rhel-5.11-x86_64",
          "rhel-5.11-i386",
          "oracle-7.3-x86_64",
          "oracle-6.9-x86_64",
          "oracle-6.9-i386",
          "oracle-5.11-x86_64",
          "oracle-5.11-i386",
          "opensuse-leap-42.2-x86_64",
          "macosx-10.9",
          "macosx-10.11",
          "macosx-10.10",
          "macos-10.12",
          "freebsd-11.0-amd64",
          "freebsd-10.3-i386",
          "freebsd-10.3-amd64",
          "fedora-26-x86_64",
          "fedora-25-x86_64",
          "fedora-25-i386",
          "fedora-24-x86_64",
          "fedora-24-i386",
          "debian-9.0-i386",
          "debian-9.0-amd64",
          "debian-8.8-i386",
          "debian-8.8-amd64",
          "debian-7.11-i386",
          "debian-7.11-amd64",
          "centos-7.3-x86_64",
          "centos-6.9-x86_64",
          "centos-6.9-i386",
          "centos-6.8-x86_64",
          "centos-5.11-i386",
     ]

     client
          .resizeWindow(1440, 953)
          .url('https://atlas.hashicorp.com/session')
          .waitForElementVisible("form#new_user input[name='user[password]']", DEFAULT_TIMEOUT)
          .click("form#new_user input[name='user[password]']")
          .waitForElementVisible("form#new_user input[name='user[password]']", DEFAULT_TIMEOUT)
          .click("form#new_user input[name='user[password]']")
          .waitForElementVisible("input[name='user[login]']", DEFAULT_TIMEOUT)
          .setValue("input[name='user[login]']", "alpine-digital-research")
          .waitForElementVisible("input[name='user[password]']", DEFAULT_TIMEOUT)
          .setValue("input[name='user[password]']", "")
          .waitForElementVisible("form#new_user input[type=submit][value='Sign in']", DEFAULT_TIMEOUT)
          .click("form#new_user input[type=submit][value='Sign in']")
     .useXpath()
          .waitForElementVisible("//h1[normalize-space(text())='Vagrant has been migrated to Vagrant Cloud']", DEFAULT_TIMEOUT)

     var box;

     for (var i in boxes) {
          box = boxes[i]

          console.log("working on box", box)

          client
           /* submit form */
               .url('https://atlas.hashicorp.com/builds/new')
           .useCss()
               .waitForElementVisible("form#new_operations_build_configuration input[name='operations_build_configuration[name]']", DEFAULT_TIMEOUT)
               .click("form#new_operations_build_configuration input[name='operations_build_configuration[name]']")
               .waitForElementVisible("input[name='operations_build_configuration[name]']", DEFAULT_TIMEOUT)
               .setValue("input[name='operations_build_configuration[name]']", box)
               .waitForElementVisible("form#new_operations_build_configuration input[name='github_enabled']", DEFAULT_TIMEOUT)
               .click("form#new_operations_build_configuration input[name='github_enabled']")
               .waitForElementVisible("div.repository div.selectize-control", DEFAULT_TIMEOUT)
               .click("div.repository div.selectize-control")
               .waitForElementVisible("div[data-value='alpine-digital-research/bento']", DEFAULT_TIMEOUT)
               .click("div[data-value='alpine-digital-research/bento']")
               .click("form#new_operations_build_configuration input[name='operations_build_configuration[github_path]']")
               .setValue("input[name='operations_build_configuration[github_path]']", "/")
               .setValue("input[name='operations_build_configuration[github_template_path]']", box + ".json")
               .click("form#new_operations_build_configuration input[type=submit][value='Create']")
          .useXpath()
               .pause(DEFAULT_TIMEOUT)

           //     .url('https://atlas.hashicorp.com/packer/alpine-digital-research/build-configurations/' + box + '/settings')
           // /* submit form */
           // .useCss()
           //     .waitForElementVisible("#edit_item > .check", DEFAULT_TIMEOUT)
           //     .click("#edit_item > .check")
           //     .waitForElementVisible("form#edit_item input[name='item[is_private]']", DEFAULT_TIMEOUT)
           //     .click("form#edit_item input[name='item[is_private]']")
           //     .waitForElementVisible("#item_periodic_build_interval", DEFAULT_TIMEOUT)
           //     .click("#item_periodic_build_interval")
           //     .click("#item_periodic_build_interval option[value=1440]")
           //     .waitForElementVisible("form#edit_item input[type=submit][value='Save']", DEFAULT_TIMEOUT)
           //     .click("form#edit_item input[type=submit][value='Save']")
           // /* submit form */
           // .useXpath()
           //     .waitForElementVisible("//a[normalize-space(text())='configurations']", DEFAULT_TIMEOUT)
           //     .click("//a[normalize-space(text())='configurations']")
           // .useCss()
     }

     return client
 }
};