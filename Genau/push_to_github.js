const simpleGit = require('simple-git');
const path = require('path');

const repoDir = path.resolve(__dirname); // Assuming the script is in the root of the project
const git = simpleGit(repoDir);

const commitMessage = 'Retrieved metadata from Salesforce org';

async function commitAndPush() {
  try {
    // Stage all changes
    await git.add('./*');
    
    // Commit changes
    await git.commit(commitMessage);
    
    // Push changes
    await git.push('origin', 'main'); // Replace 'main' with your branch name if different
    
    console.log('Changes pushed to GitHub successfully!');
  } catch (error) {
    console.error('Error pushing changes to GitHub:', error);
  }
}

commitAndPush();
