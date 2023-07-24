// server.test.ts
import Server from '../src/server';

describe('Server', () => {
  it('should start the server successfully', () => {
    const server = new Server();

    // Mocking connectToDatabase and connectToFirebase functions
    server['connectToDatabase'] = () => true;
    server['connectToFirebase'] = () => true;

    // Mocking createServer function to return true
    server['createServer'] = () => true;

    // Redirect console.log to suppress logs during testing
    const originalConsoleLog = console.log;
    console.log = () => {};

    server.start();

    // Restore console.log
    console.log = originalConsoleLog;
  });

  it('should fail to start the server when the database connection fails', () => {
    const server = new Server();

    // Mocking connectToDatabase function to return false
    server['connectToDatabase'] = () => false;

    // Redirect console.log to suppress logs during testing
    const originalConsoleLog = console.log;
    console.log = () => {};

    server.start();

    // Restore console.log
    console.log = originalConsoleLog;
  });

  it('should fail to start the server when the Firebase connection fails', () => {
    const server = new Server();

    // Mocking connectToDatabase function to return true
    server['connectToDatabase'] = () => true;

    // Mocking connectToFirebase function to return false
    server['connectToFirebase'] = () => false;

    // Redirect console.log to suppress logs during testing
    const originalConsoleLog = console.log;
    console.log = () => {};

    server.start();

    // Restore console.log
    console.log = originalConsoleLog;
  });
});