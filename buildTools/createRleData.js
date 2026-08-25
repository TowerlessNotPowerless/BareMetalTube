if (process.argv.length != 4) {
	console.error("Usage: npm run createRleData sourceFilename destinationFilename");
	process.exitCode = -1;
	return;
}

const fs = require('node:fs');

const filenameIn = process.argv[2];
const filenameOut = process.argv[3];

const inputData = fs.readFileSync(filenameIn);
const outputData = [];

let repeatCount = 0;
let repeatValue = 0;

const startNewRepeatValue = (i) => {
	if (repeatCount == 1) {
		if (repeatValue == 0xff) {
			outputData.push(0xff);
			outputData.push(1);
		}
	} else {
		outputData.push(0xff);
		outputData.push(repeatCount);
	}
	outputData.push(repeatValue);

	repeatCount = 1;
	if (i < inputData.length) {
		repeatValue = inputData[i];
	}
}

const continueRepeatValue = () => {
	repeatCount++;
	if (repeatCount == 0x101) {
		outputData.push(0xff);
		outputData.push(0);
		outputData.push(repeatValue);
		repeatCount = 1;
	}
}

for (let i = 0; i < inputData.length; i++) {
	if (i == 0) {
		repeatCount = 1;
		repeatValue = inputData[i];
	} else {
		if (repeatValue == inputData[i]) {
			continueRepeatValue();
		} else {
			startNewRepeatValue(i);
		}
	}
}

//	send any final bytes left in the repeating stream
startNewRepeatValue(inputData.length);

fs.writeFileSync(filenameOut, new Uint8Array(outputData));

