// Set up node in test environment
process.env.NODE_ENV = 'test';

// Allow coffee script for testing
require('coffee-script');

// Add non-npm package assert-extra built by peepcode
require(__dirname + '/assert-extra');