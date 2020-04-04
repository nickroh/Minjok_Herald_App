// Your web app's Firebase configuration
	var firebaseConfig = {
		apiKey: "AIzaSyAnovu3lcdiNmMMzS7xi1WM2LssMPFKSMk",
		authDomain: "minjok-herald.firebaseapp.com",
		databaseURL: "https://minjok-herald.firebaseio.com",
		projectId: "minjok-herald",
		storageBucket: "minjok-herald.appspot.com",
		messagingSenderId: "701541587970",
		appId: "1:701541587970:web:6321ea25bd8c8552549b1b",
		measurementId: "G-ZLQJJPQCLG"
	};
  // Initialize Firebase
  
  firebase.initializeApp(firebaseConfig);
  

const txtEmail = document.getElementById('Email')
const txtPassword = document.getElementById('Pass')
const btnLogin = document.getElementById('Login')
const btnSignup = document.getElementById('Signup')

firebase.auth().onAuthStateChanged(firebaseUser => {
  if(firebaseUser){
    console.log(firebaseUser)
  }else{
    console.log('not logged in')
  }
});

function login(){
  const email = txtEmail.value;
  const pass = txtPassword.value;
  const auth = firebase.auth();

  const promise = auth.signInWithEmailAndPassword(email,pass);
  promise.catch(e => console.log(e.message))
}     
        
    

    


