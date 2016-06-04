# Contributing

Contributions are **welcome** and will be fully **credited**.

We accept contributions via Pull Requests on [Github](https://github.com/react-native-contrib/react-native-heyzap).

## Guidelines

- **React Native 0.26:** `react-native-heyzap` has a minimum peer dependency requirement on React Native 0.26.*. Pull requests must not require a version greater than this unless the feature is only utilized conditionally.

- **Add tests!:** All pull requests must include unit tests to ensure the change works as expected and to prevent regressions.

- **Document any change in behaviour:** Make sure the `README.md` and any other relevant documentation are kept up-to-date.

- **Consider our release cycle:** We try to follow [SemVer v2](http://semver.org/). Randomly breaking public APIs is not an option.

- **Use Git Flow:** Don't ask us to pull from your master branch. Set up [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) and create a new feature branch from `develop`.

- **One pull request per feature:** If you want to do more than one thing, send multiple pull requests.

- **Send coherent history:** Make sure each individual commit in your pull request is meaningful. If you had to make multiple intermediate commits while developing, please [squash them](http://www.git-scm.com/book/en/v2/Git-Tools-Rewriting-History#Changing-Multiple-Commit-Messages) before submitting.


## Running tests

In order to contribute, you'll need to checkout the source from GitHub and install dependencies using Composer:

``` bash
$ git clone https://github.com/react-native-contrib/react-native-heyzap.git
$ cd react-native-heyzap && npm install
$ npm test
```

## Reporting a security vulnerability

We want to ensure that `react-native-heyzap` is secure for everyone. If you've discovered a security vulnerability, we appreciate your help in disclosing it to us in a [responsible manner](http://en.wikipedia.org/wiki/Responsible_disclosure).

Publicly disclosing a vulnerability can put the entire community at risk. If you've discovered a security concern, please email us at contact@hassankhan.me. We'll work with you to make sure that we understand the scope of the issue, and that we fully address your concern. We consider correspondence sent to this email address our highest priority, and work to address any issues that arise as quickly as possible.

After a security vulnerability has been corrected, a security hotfix release will be deployed as soon as possible.


**Happy coding**!
