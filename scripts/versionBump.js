const fs = require("fs");
const { execSync } = require("child_process");

const getCurrentVersion = () => {
  const pubspec = fs.readFileSync("pubspec.yaml", "utf8");
  const version = pubspec.match(/version: (.*)/)[1];
  return version;
};

const getNewVersion = (currentVersion) => {
  let [major, minor, patch, versionCode = 0] = currentVersion
    .split(/\.|\+/)
    .map((v) => parseInt(v));

  if (patch >= 9) {
    minor++;
    patch = 0;
  } else {
    patch++;
  }

  return {
    version: `${major}.${minor}.${patch}`,
    versionCode: versionCode + 1,
  };
};

const updatePubSpec = (newVersion) => {
  const pubspec = fs.readFileSync("pubspec.yaml", "utf8");
  const newPubspec = pubspec.replace(
    /version: (.*)/,
    `version: ${newVersion.version}+${newVersion.versionCode}`
  );
  fs.writeFileSync("pubspec.yaml", newPubspec);
};

const updateReadme = (newVersion) => {
  const readme = fs.readFileSync("README.md", "utf8");
  const newReadme = readme.replace(/v\d+\.\d+\.\d+/g, `v${newVersion.version}`);
  fs.writeFileSync("README.md", newReadme);
};

const currentVersion = getCurrentVersion();
const newVersion = getNewVersion(currentVersion);
console.log(`Bumping version from ${currentVersion} to ${newVersion.version}`);

updateReadme(newVersion);
updatePubSpec(newVersion);

execSync("flutter pub get");
