
var intervalMax = 3000;
var intervalMin = 2000;
var postStimulusDelay = 2000;

var remainingTestCount = 0;
var testCount = 0;

var startTimestamp = 0;
var reactionTimestamp = 0;
var interval = 0;

var results = "testNumber, timestamp, interval, reactionDelay<br>";
var resultsDisplayed = false

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function getRndInteger(min, max) {
    return Math.floor(Math.random() * (max - min)) + min;
}

function testsComplete() {
    return remainingTestCount == 0;
}

async function runStimulus() {
    startTimestamp = Date.now()
    document.body.style.backgroundColor = "red";
}

async function runInterval() {
    remainingTestCount -= 1;

    document.getElementById("reactionTimeMessage").innerHTML = "";
    document.body.style.backgroundColor = "black";
    interval = getRndInteger(intervalMin, intervalMax);

    await sleep(interval);
    runStimulus();
}

async function displayResults() {
    resultsDisplayed = true
    document.body.style.backgroundColor = "white";
    document.getElementById("reactionTimeMessage").style.display = "none";
    document.getElementById("resultsMessage").innerHTML = results;
}

async function handleOnClick() {

    if (testsComplete() && resultsDisplayed) {
        return
    }

    reactionTimestamp = Date.now();

    var reactionDelay = reactionTimestamp - startTimestamp;
    var testNumber = (testCount - remainingTestCount) - 1
    document.getElementById("reactionTimeMessage").innerHTML = reactionDelay;

    var resultsCsv =
        testNumber + ", " +
        Date.now() + ", " +
        interval + ", " +
        reactionDelay + "<br>";
    results += resultsCsv;

    await sleep(postStimulusDelay);

    if (testsComplete()) {
        displayResults();
    } else {
        runInterval();
    }
}

function runTest() {
    testCount = document.getElementById("pvtCount").value;
    remainingTestCount = document.getElementById("pvtCount").value;

    document.getElementById("startScreen").style.display = "none";
    document.getElementById("pvtScreen").style.display = "block";
    runInterval();
}

