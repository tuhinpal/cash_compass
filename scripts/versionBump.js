const fs = require("fs");

const getCurrentVersion = () => {
  const pubspec = fs.readFileSync("pubspec.yaml", "utf8");
  const version = pubspec.match(/version: (.*)/)[1];
  return version;
};

const getNewVersion = (currentVersion) => {
  let [major, minor, patch] = currentVersion.split(".").map((v) => parseInt(v));

  if (patch >= 9) {
    minor++;
    patch = 0;
  } else {
    patch++;
  }

  return `${major}.${minor}.${patch}`;
};

const updatePubSpec = (newVersion) => {
  const pubspec = fs.readFileSync("pubspec.yaml", "utf8");
  const newPubspec = pubspec.replace(/version: (.*)/, `version: ${newVersion}`);
  fs.writeFileSync("pubspec.yaml", newPubspec);
};

const updateReadme = (newVersion) => {
  const readme = fs.readFileSync("README.md", "utf8");
  const newReadme = readme.replace(/v\d+\.\d+\.\d+/g, `v${newVersion}`);
  fs.writeFileSync("README.md", newReadme);
};

const currentVersion = getCurrentVersion();
const newVersion = getNewVersion(currentVersion);
console.log(`Bumping version from ${currentVersion} to ${newVersion}`);

updateReadme(newVersion);
updatePubSpec(newVersion);
