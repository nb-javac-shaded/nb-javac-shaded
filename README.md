# nb-javac Shaded

[![](https://jitpack.io/v/nb-javac-shaded/nb-javac-shaded.svg)](https://jitpack.io/#nb-javac-shaded/nb-javac-shaded)

Shaded versions of [nb-javac](https://github.com/oracle/nb-javac) to avoid OSGi/Equinox classloader conflicts.

## Why?

nb-javac provides a backported Java compiler that allows parsing modern Java syntax (Java 26+) while running on Java 8. However, when bundling nb-javac JARs in an Eclipse/OSGi environment, the Equinox classloader conflicts with JDK classes in packages like `com.sun.tools.javac.*`, causing `ClassCastException`s.

This project fetches nb-javac from Maven Central and shades it by relocating all packages to use a `shaded.` prefix, eliminating classloader conflicts.

## Upstream

This project shades the official nb-javac releases published by DukeScript at:
- Maven Central: `com.dukescript.nbjavac:nb-javac`
- Current version: `jdk-26+35`
- Source: https://github.com/oracle/nb-javac

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
    <groupId>com.github.nb-javac-shaded.nb-javac-shaded</groupId>
    <artifactId>nb-javac-shaded</artifactId>
    <version>jdk-26+35</version>
  </dependency>
  
  <!-- API JAR -->
  <dependency>
    <groupId>com.github.nb-javac-shaded.nb-javac-shaded</groupId>
    <artifactId>nb-javac-api-shaded</artifactId>
    <version>jdk-26+35</version>
  </dependency>
</dependencies>
```

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

Build the shaded JARs:
```bash
mvn clean install
```

Find shaded JARs in:
- `nb-javac-shaded/target/nb-javac-shaded-jdk-26+35.jar`
- `nb-javac-api-shaded/target/nb-javac-api-shaded-jdk-26+35.jar`

The build automatically fetches `com.dukescript.nbjavac:nb-javac:jdk-26+35` from Maven Central and shades it.

## Updating to newer versions

To update to a newer nb-javac version:

1. Check for new releases at https://repo1.maven.org/maven2/com/dukescript/nbjavac/nb-javac/
2. Update `<nbjavac.version>` in the parent `pom.xml`
3. Update the `<version>` in all POMs to match
4. Rebuild and test
5. Tag and push to trigger a new JitPack build

## Publishing to JitPack

This project is published via JitPack:

1. Create and push a tag matching the nb-javac version: `git tag jdk-26+35 && git push --tags`
2. JitPack automatically builds when someone requests the version
3. View build status at: https://jitpack.io/#nb-javac-shaded/nb-javac-shaded

## License

This project only repackages nb-javac. nb-javac is licensed under GPL-2.0. See [nb-javac's license](https://github.com/oracle/nb-javac/blob/master/LICENSE) for details.
