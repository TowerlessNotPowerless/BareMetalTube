if (process.argv.length != 3) {
	console.error("Usage: npm run createExports componentFilename");
	process.exitCode = -1;
	return;
}

const fs = require('node:fs');

const exportString = ".export";

const filenameBase = process.argv[2];
const filenameIn = `${filenameBase}.lst`;
const filenameOut = `${filenameBase}Exports.asm`;

fs.readFile(filenameIn, 'utf8', (err, data) => {
	if (err) {
		console.error(err);
		return;
	}
	processListingFile(data);
});

const processListingFile = (data) => {
	let exportedLabels = [];
	const listingLines = data.split("\n");
	listingLines.forEach(line => {
		const exportedLabelName = getExportedLabelName(line);
		if (exportedLabelName != null) {
			exportedLabels.push({
				name: exportedLabelName
			});
		}
	});
	exportedLabels.sort(labelCompareNames);

	const assemblyLines = [];
	exportedLabels.forEach(label => {
		label.value = getLabelAddress(listingLines, label.name);
		if (label.value != -1) {
			const assemblyLine = `${label.name}\tequ\t$${label.value.toString(16)}`;
			assemblyLines.push(assemblyLine);
		}
	});
	assemblyLines.push("");

	const asm = assemblyLines.join("\r\n");
	fs.writeFile(filenameOut, asm, { flag: 'w+' }, err => {
		if (err) {
			console.error(`Unable to write to ${filenameOut}: ${err}`);
			process.exitCode = -1;
		}
	})
};

const getExportedLabelName = (line) => {
	const pattern = new RegExp(`^(.+)${exportString}(zp)?\\s(.*)(\\s*)\r`);
	const match = line.match(pattern);
	if (match != null) {
		return match[3];
	}
	return null;
}

const getLabelAddress = (listingLines, label) => {
	const pattern = new RegExp(`^([0-9a-fA-F]{4,6})(\\s+)([0-9]{1,10})(\\s+)((\\.proc\\s+)*)(${label})(\\s*)\\r`);
	const lineCount = listingLines.length;
	for (let i = 0; i < lineCount; i++) {
		const line = listingLines[i];
		const match = line.match(pattern);
		if (match != null) {
			return parseInt(`0x${match[1]}`, 16);
		}
	}

	return -1;
}

const labelCompareNames = (a, b) => {
	if (a.name < b.name) {
		return -1;
	}
	if (a.name > b.name) {
		return 1;
	}
	return 0;
}
