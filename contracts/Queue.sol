pragma solidity ^0.5.0;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

import './utils/SafeMath.sol';

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint256 timeLimit;

	struct Buyer {
		address addr;
		uint256 entryTime;
	}

	mapping(uint8 => Buyer) queue;
	uint8 first;
	uint8 last;

	/* Add events */
	event TimeUp(address ejectedBuyerAddress);

	/* Add constructor */
	constructor(uint256 _timeLimit) public {
		timeLimit = _timeLimit;
		first = 1;
		last = 0;
	}

	/* Returns the number of people waiting in line */
	function qsize() view public returns(uint8) {
		//TODO: Unsafe?
		return last - first + 1;
	}

	/* Returns whether the queue is empty or not */
	function empty() view public returns(bool) {
		return (last < first);
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() view public returns(address) {
		return queue[first].addr;
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() view public returns(uint8) {
		for(uint8 i = first; i < last; ++i){
			if(msg.sender == queue[i].addr) return (i - first + 1);
		}
		return 0; // for not in queue
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() public {
		if(SafeMath.sub(now, queue[first].entryTime) > timeLimit){
			dequeue();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() public {
		require(first <= last);
		delete queue[first];
		first += 1;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) public {
		last += 1;
		queue[last] = Buyer(addr, now);
	}
}
