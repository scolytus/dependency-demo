# dependency-demo

In this repo I store some demo cases related to software composition analysis.
Some helper scripts help to run tools like [Dependency-Track](https://dependencytrack.org/)
and [Dependency-Check](https://owasp.org/www-project-dependency-check/).

You can also find [SBOMs](boms) in [CycloneDX](https://cyclonedx.org/) and [SPDX](https://spdx.org/) format.

For the Spring Boot projects, also dependency-check reports are checked-in for reference.

## Projects

### Angular Projects

* projects are created with `ng new`
* `cyclonedx-bom` is used to generate a SBOM for the new project

### Spring Boot Projects

* Spring Boot projects are created using the [Spring Initializr](https://start.spring.io/).

## Outputs

### SBOMs

* CycloneDX - Created using [`cyclonedx-maven-plugin`](https://github.com/CycloneDX/cyclonedx-maven-plugin)
* SPDX - Created using [`spdx-maven-plugin`](https://github.com/spdx/spdx-maven-plugin)

### Reports 

* dependency-check
  * `reports/*.html` - created using [`dependency-check-maven`](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/index.html)
  * `reports/*.cli.clean.html` - created using [dependency-check CLI tool](https://jeremylong.github.io/DependencyCheck/dependency-check-cli/index.html) after `mvn clean`
  * `reports/*.cli.packaged.html` - created using [dependency-check CLI tool](https://jeremylong.github.io/DependencyCheck/dependency-check-cli/index.html) after `mvn package`

## Links

* "A ridiculously bloated non-functional project designed to produce a large number of dependencies":
  [package.json](https://gist.github.com/stevespringett/4d3c39aceb48d9487f644c85845dfe6c)

## Thanks

* I want to thank Steve Springett and the community for the work on [Dependency-Track](https://dependencytrack.org/)
and [CycloneDX](https://cyclonedx.org/).
* I also want to thank the [Dependency-Check](https://owasp.org/www-project-dependency-check/) community.
