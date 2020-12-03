# OpticalMFADetermination

Work in progress.

## Format for input
The data is mainly supplied via the matrix **IntensitySweep** which contains one row for each observation recorded. The columns in **IntensitySweep** correspond to 

    Column 1: MFA value used. 
    This value is always known when generating intensity values from a model, but never known when 
    doing real experiments. If it is not known, assign a column of nan values.

    Column 2: Wall thickness used. 
    Same as above.

    Column 3: pAngle.
    Polarizer position in radians.

    Column 4: aAngle.
    Analyzer position in radians.

    Column 5: wavelength.
    Wavelength of the light used in the experiment.

    Column 6: time.
    This is an unnecessary column and can be omitted. It is used to check that the data export was correct
    when generating intensity values from a model.

    Column 7: Intensity
    These are the intensities recorded during the experiment.
