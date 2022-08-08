import './App.css';
import { Row, Container, Col } from "reactstrap";
import Rfart from './artifacts/contracts/Rfart.sol/Rfart.json'
import Faucet from './components/Faucet.js'

function App() {

  const Token = Rfart;

  return (
    <div className="App">
    <Container>
    <Row className="justify-content-md-center">
      <Col>
      <div className="faucet-title">Rfart faucet</div>
      </Col>
    </Row>
    <Faucet  tokenContract={Token}/>
    </Container>
    </div>
  );
}

export default App;