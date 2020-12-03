const fs = require("fs");
const readline = require("readline");

const compute = ({ right = 3, down = 1, input = "./input" } = {}) => {
  const readInterface = readline.createInterface({
    input: fs.createReadStream(input),
    console: false,
  });

  return new Promise((resolve) => {
    let col = 0,
      lineNo = 0,
      trees = -1;
    readInterface.on("line", (line) => {
      if (trees == -1) return (trees = 0);
      if (++lineNo % down != 0) return;
      trees += line[(col += right) % line.length] == "#" ? 1 : 0;
    });
    readInterface.on("close", () => resolve(trees));
  });
};

const firstTask = async () => console.log(`First part: ${await compute()}`);
const secondTask = async () => {
  let result = await Promise.all(
    [
      { right: 1, down: 1 },
      { right: 3, down: 1 },
      { right: 5, down: 1 },
      { right: 7, down: 1 },
      { right: 1, down: 2 },
    ].map(({ right, down }) => compute({ right, down, input: "./input" }))
  ).then((r) => r.reduce((p, c) => p * c, 1));

  console.log(`Second part: ${result}`);
};

firstTask() && secondTask();
