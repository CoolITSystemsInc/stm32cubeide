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

## References

If this does not build, please check the main.yml file from mfs-adapter project.
