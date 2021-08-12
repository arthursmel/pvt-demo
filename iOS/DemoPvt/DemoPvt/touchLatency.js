
var remainingTestCount = 100;

async function handleOnClick() {
    var reactionTimestamp = Date.now();

    if (remainingTestCount == 0) {
        document.body.style.backgroundColor = "red";
        return;
    }

    remainingTestCount -= 1;

    var curResults = document.getElementById("resultsMessage").innerHTML;
    document.getElementById("resultsMessage").innerHTML = curResults + "<br>" + reactionTimestamp;
}



