# nb-javac Shaded

[![](https://jitpack.io/v/GITHUB_USERNAME/nbjavac-shaded.svg)](https://jitpack.io/#GITHUB_USERNAME/nbjavac-shaded)

Shaded versions of [nb-javac](https://github.com/oracle/nb-javac) to avoid OSGi/Equinox classloader conflicts.

## Why?

nb-javac provides a backported Java compiler that allows parsing modern Java syntax (Java 26+) while running on Java 8. However, when bundling nb-javac JARs in an Eclipse/OSGi environment, the Equinox classloader conflicts with JDK classes in packages like `com.sun.tools.javac.*`, causing `ClassCastException`s.

This project shades nb-javac by relocating all packages to use a `shaded.` prefix, eliminating classloader conflicts.

## Usage

Add the JitPack repository and dependencies to your `pom.xml`:

```xml
<repositories>
  <repository>
    <id>jitpack.io</id>
    <url>https://jitpack.io</url>
  </repository>
</repositories>

<dependencies>
  <!-- Main compiler JAR -->
  <dependency>
    <groupId>com.github.GITHUB_USERNAME.nbjavac-shaded</groupId>
    <artifactId>nb-javac-shaded</artifactId>
    <version>26.27</version>
  </dependency>
  
  <!-- API JAR -->
  <dependency>
    <groupId>com.github.GITHUB_USERNAME.nbjavac-shaded</groupId>
    <artifactId>nb-javac-api-shaded</artifactId>
    <version>26.27</version>
  </dependency>
</dependencies>
```

Replace `GITHUB_USERNAME` with the actual GitHub username/org where this repo is published.

## What's included?

Two shaded artifacts:
- `nb-javac-shaded` - main compiler JAR (3.6MB)
- `nb-javac-api-shaded` - API JAR (1.7MB)

## Package relocations

All packages are prefixed with `shaded.`:

- `com.sun.tools.*` → `shaded.com.sun.tools.*`
- `com.sun.source.*` → `shaded.com.sun.source.*`
- `javax.annotation.processing` → `shaded.javax.annotation.processing`
- `javax.lang.*` → `shaded.javax.lang.*`
- `javax.tools` → `shaded.javax.tools`

## Building

1. Place the original nb-javac JARs in the `lib/` directory:
   - `lib/nb-javac-jdk-26+27.jar`
   - `lib/nb-javac-jdk-26+27-api.jar`

2. Install the original JARs to your local Maven repository (one-time step):
   ```bash
   mvn install:install-file -Dfile=lib/nb-javac-jdk-26+27.jar \
       -DgroupId=local -DartifactId=nb-javac-original \
       -Dversion=26.27 -Dpackaging=jar -DgeneratePom=true
   
   mvn install:install-file -Dfile=lib/nb-javac-jdk-26+27-api.jar \
       -DgroupId=local -DartifactId=nb-javac-api-original \
       -Dversion=26.27 -Dpackaging=jar -DgeneratePom=true
   ```

3. Build the shaded JARs:
   ```bash
   mvn clean install
   ```

4. Find shaded JARs in:
   - `nb-javac-shaded/target/nb-javac-shaded-26.27.jar` (3.6MB)
   - `nb-javac-api-shaded/target/nb-javac-api-shaded-26.27.jar` (1.7MB)

## Current status

This build uses pre-compiled nb-javac JARs (committed to this repo under `lib/`) that include an unreleased patch for Eclipse URL handling. Once nb-javac publishes an official release containing this patch, this project can be updated to fetch and shade their published artifacts directly from Maven Central.

## Publishing to JitPack

This project is set up to be published via JitPack:

1. Push this repository to GitHub
2. Create and push a tag: `git tag v26.27 && git push --tags`
3. JitPack will automatically build when someone requests the version
4. View build status at: `https://jitpack.io/#GITHUB_USERNAME/nbjavac-shaded`

## License

This project only repackages nb-javac. nb-javac is licensed under GPL-2.0. See [nb-javac's license](https://github.com/oracle/nb-javac/blob/master/LICENSE) for details.
