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

## Description of the functions
Broadly speaking there are three classes of functions in this repository:

1. **Derivations**
These files are typically stand-alone scripts that use MATLABs symbolic engine to derive analytical expressions for sought quantities.

2. **Demo files**
These files function as demonstrations. They generally work as a self-contained script calling input, processing functions and plotting/output functions.

3. **Functions**
These are the files that do the calculations. They can/should be called from other workflows as necessary.


## Function descriptions

**Derivations**

*symbolicDerivationOfStationaryAnalyzer.m*

Derives intensity as a function of polarizer, analyzer, mfa and wall thickness under assumption that the polarizer is moving.

*symbolicDerivationOfStationaryPolarizer.m*

Derives intensity as a function of polarizer, analyzer, mfa and wall thickness under assumption that the analyzer is moving.
