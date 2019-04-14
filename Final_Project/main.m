imagemap = './modelcastlePNG/';
imagemap = './TeddyBearPNG/';

files=dir(strcat(imagemap, '*.png'));
reconstruction_demo(imagemap, files);
