# Docker image for STM32CubeIDE Development Utility

Source: https://www.st.com/en/development-tools/stm32cubeide.html

## Usage

To build, create a new workflow for your project. While this may run on ubuntu-latest, it has only been tested with ubuntu-18.04, so please use that. Add or change the following lines.

Change the line what-to-build to be the path to the folder containing the .cproject file. For example, './Boards/MFS_F410CBU_A'. Be sure to use single quotes if the path has any spaces in it (Pro-tip, don't use spaces in the path).

```yaml
      # Get STM32 Docker Image
      - name: Build Firmware
        uses: CoolITSystemsInc/stm32cubeide@HEAD
        with:
          what-to-build: '<project-folder>'
          
      # Upload artifacts
      - uses: actions/upload-artifact@v2
        with:
          name: artifacts
          path: |
            <project-folder>/Debug/*.bin
            <project-folder>/Debug/*.elf
            <project-folder>/Debug/*.list
            <project-folder>/Debug/*.map
```

## Note

This builder runs in Ubuntu and **DOES NOT** support running batch files. Do not use DOS-style batch files.

## Manually running your Action

Click "Actions" at the top and the click "CI" on the left under All Workflows. There should be a message on the right saying, "This workflow has a workflow_dispatch event trigger". Click the "Run workflow" drop down menu and then click "Run workflow".

## Adding your Build Badge

Click "Actions" at the top and the click "CI" on the left under All Workflows. To the right of the search box there should be a elipses button. Click to open a pop-up menu and choose "Create status badge." Here, change the Branch to master and leave the event on Default. Click "Copy status badge Markdown."

Now, naviagte to your project's README.md file which should be in the root folder of every project. Edit the readme and paste the markdown script to the top of the file, normally right under the project title.

## Getting your Artifacts

Click "Actions" at the top and the click "CI" on the left under All Workflows. Click on any of your recent runs; if there aren't any, see the preceeding step on how to manually run your action. This should show you the reason for the build (e.g., user pushed), the Status, Total duration, Billable time and the number of artifacts. Since these are always zipped, and if the action was successful, this should be "1".

Below the main.yml should be the Artifacts section with the contents of the artifacts.

## References

If this does not build, please check the main.yml file from mfs-adapter project.
