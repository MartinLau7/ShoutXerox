import XCTest
@testable import ShoutXerox

struct ShoutServer {
	static let host = ""
	static let username = ""
	static let password = ""
	static let agentAuth = SSHAgent()
	static let passwordAuth = SSHPassword(password)
	
	static let authMethod = agentAuth
}

final class ShoutXeroxTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
		let ssh = try SSH(host: ShoutServer.host)
		try ssh.authenticate(username: ShoutServer.username, privateKey: "")
		let sftp = try ssh.openSftp()
		try sftp.upload(localURL: URL(fileURLWithPath: "~/123.png"), remotePath: "~/123.png")
    }
}
