# Publishing Guide

## Initial Setup

1. **GitHub repository**: https://github.com/nb-javac-shaded/nb-javac-shaded

2. **Create and push a release tag** (matching the nb-javac version):
   ```bash
   git tag jdk-26+35
   git push origin jdk-26+35
   ```

## Using the Published Artifact

Once published to JitPack, consumers can use it by adding:

```xml
<repositories>
  <repository>
    <id>jitpack.io</id>
    <url>https://jitpack.io</url>
  </repository>
</repositories>

<dependencies>
  <dependency>
    <groupId>com.github.nb-javac-shaded.nb-javac-shaded</groupId>
    <artifactId>nb-javac-shaded</artifactId>
    <version>jdk-26+35</version>
  </dependency>
  <dependency>
    <groupId>com.github.nb-javac-shaded.nb-javac-shaded</groupId>
    <artifactId>nb-javac-api-shaded</artifactId>
    <version>jdk-26+35</version>
  </dependency>
</dependencies>
```

## Build Status

After pushing the tag, check the build at:
- https://jitpack.io/#nb-javac-shaded/nb-javac-shaded

The first request triggers the build. It may take a few minutes.

## Future Releases

When a new nb-javac version is released:

1. Update `<nbjavac.version>` in `pom.xml`
2. Update all `<version>` tags to match
3. Build and test: `mvn clean install`
4. Commit changes
5. Tag a new release: `git tag jdk-XX+YY && git push origin jdk-XX+YY`

## Eclipse Integration

In your Eclipse extension's `pom.xml`:

1. Add the JitPack repository
2. Add the shaded dependencies
3. Update all `import` statements from original packages to `shaded.*` equivalents:
   - `import com.sun.tools.*` → `import shaded.com.sun.tools.*`
   - `import com.sun.source.*` → `import shaded.com.sun.source.*`
   - `import javax.tools.*` → `import shaded.javax.tools.*`
   - etc.
