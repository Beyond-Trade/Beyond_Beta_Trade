'use strict';

const Web3 = require('web3');
const sym2addr = require('./issue_addr.json');

const aggregatorV3InterfaceABI = [
	{
		"inputs":[],
		"name":"decimals",
		"outputs":[{
			"internalType":"uint8",
			"name":"",
			"type":"uint8"}],
		"stateMutability":"view",
		"type":"function"},
	{
		"inputs":[],
		"name":"description",
		"outputs":[{
			"internalType":"string",
			"name":"","type":"string"}],
		"stateMutability":"view",
		"type":"function"},
	{
		"inputs":[{"internalType":"uint80","name":"_roundId","type":"uint80"}],
		"name":"getRoundData",
		"outputs":[
			{
				"internalType":"uint80",
				"name":"roundId",
				"type":"uint80"},
			{
				"internalType":"int256",
				"name":"answer",
				"type":"int256"},
			{
				"internalType":"uint256",
				"name":"startedAt",
				"type":"uint256"},
			{
				"internalType":"uint256",
				"name":"updatedAt",
				"type":"uint256"},
			{
				"internalType":"uint80",
				"name":"answeredInRound",
				"type":"uint80"}],
		"stateMutability":"view",
		"type":"function"},
	{
		"inputs":[],
		"name":"latestRoundData",
		"outputs":[
			{
				"internalType":"uint80",
				"name":"roundId",
				"type":"uint80"},
			{
				"internalType":"int256",
				"name":"answer",
				"type":"int256"},
			{
				"internalType":"uint256",
				"name":"startedAt",
				"type":"uint256"},
			{
				"internalType":"uint256",
				"name":"updatedAt",
				"type":"uint256"},
			{
				"internalType":"uint80",
				"name":"answeredInRound",
				"type":"uint80"}],
		"stateMutability":"view",
		"type":"function"},
	{
		"inputs":[],
		"name":"version",
		"outputs":[{"internalType":"uint256","name":"","type":"uint256"}],
		"stateMutability":"view",
		"type":"function"}];

async function chainlink_tick(sym)
{
	const web3 = new Web3('https://mainnet.infura.io/v3/product-id');

	const addr = '0x8A753747A1Fa494EC906cE90E9f37563A8AF630e';		// ETH/USD

	const priceFeed = new web3.eth.Contract(aggregatorV3InterfaceABI, addr);

	const roundData = await priceFeed.methods.latestRoundData().call();

	return roundData.answer;
}


(async ()=> {

chainlink_tick('ETH/USD');

})();
