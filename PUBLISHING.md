# Publishing Guide

## Initial Setup

1. **GitHub repository**: https://github.com/nb-javac-shaded/nbjavac-shaded

2. **Create and push a release tag**:
   ```bash
   git tag v26.27
   git push origin v26.27
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
    <groupId>com.github.nb-javac-shaded.nbjavac-shaded</groupId>
    <artifactId>nb-javac-shaded</artifactId>
    <version>26.27</version>
  </dependency>
  <dependency>
    <groupId>com.github.nb-javac-shaded.nbjavac-shaded</groupId>
    <artifactId>nb-javac-api-shaded</artifactId>
    <version>26.27</version>
  </dependency>
</dependencies>
```

## Build Status

After pushing the tag, check the build at:
- https://jitpack.io/#nb-javac-shaded/nbjavac-shaded

The first request triggers the build. It may take a few minutes.

## Future Releases

When nb-javac publishes an official release with the Eclipse patch:

1. Update the build to fetch from Maven Central instead of `lib/`
2. Remove the committed JARs from git
3. Update version numbers
4. Tag a new release: `git tag vX.Y && git push origin vX.Y`

## Eclipse Integration

In your Eclipse extension's `pom.xml`:

1. Add the JitPack repository
2. Add the shaded dependencies
3. Update all `import` statements from original packages to `shaded.*` equivalents:
   - `import com.sun.tools.*` → `import shaded.com.sun.tools.*`
   - `import com.sun.source.*` → `import shaded.com.sun.source.*`
   - `import javax.tools.*` → `import shaded.javax.tools.*`
   - etc.
