package 'CruiseControlWorkflow' {
	private import ScalarValues::Real;
	
	item def SetSpeedCommand {
		attribute targetSpeed : Real;
	}
	
	item def SpeedFeedback {
		attribute actualSpeed : Real;
	}
	
	item def ThrottleInstruction {
		attribute throttleValue : Real;
	}
	
	port def SetSpeedSource {
		out item command : SetSpeedCommand;
	}
	
	port def SetSpeedSink {
		in item command : SetSpeedCommand;
	}
	
	port def SpeedFeedbackSource {
		out item measurement : SpeedFeedback;
	}
	
	port def SpeedFeedbackSink {
		in item measurement : SpeedFeedback;
	}
	
	port def ThrottleSource {
		out item instruction : ThrottleInstruction;
	}
	
	port def ThrottleSink {
		in item instruction : ThrottleInstruction;
	}
	
	action def CollectSetSpeed {
		in command : SetSpeedCommand;
		out forwardedCommand : SetSpeedCommand;
	}
	
	action def SenseSpeedFeedback {
		in measurement : SpeedFeedback;
		out reportedSpeed : SpeedFeedback;
	}
	
	action def AdjustThrottle {
		in setSpeed : SetSpeedCommand;
		in speedFeedback : SpeedFeedback;
		out throttleInstruction : ThrottleInstruction;
	}
	
	part driver {
		port setSpeedPort : SetSpeedSource;
	}
	
	part vehicle {
		part speedometer {
			port speedPort : SpeedFeedbackSource;
		}
		part engine {
			port throttlePort : ThrottleSink;
		}
		part cruiseController {
			port setSpeedPort : SetSpeedSink;
			port speedPort : SpeedFeedbackSink;
			port throttlePort : ThrottleSource;
		}
	}
	
	part cruiseControlWorkflow {
		ref driverRef :> driver;
		ref controllerRef :> vehicle::cruiseController;
		ref speedometerRef :> vehicle::speedometer;
		ref engineRef :> vehicle::engine;
		perform action collectSetSpeed : CollectSetSpeed {
			in command = driverRef.setSpeedPort.command;
			out forwardedCommand = controllerRef.setSpeedPort.command;
		}
		perform action senseSpeed : SenseSpeedFeedback {
			in measurement = speedometerRef.speedPort.measurement;
			out reportedSpeed = controllerRef.speedPort.measurement;
		}
		perform action adjustThrottle : AdjustThrottle {
			in setSpeed = collectSetSpeed.forwardedCommand;
			in speedFeedback = senseSpeed.reportedSpeed;
			out throttleInstruction = engineRef.throttlePort.instruction;
		}
	}
	
	connect driver.setSpeedPort to vehicle.cruiseController.setSpeedPort;
	connect vehicle.speedometer.speedPort to vehicle.cruiseController.speedPort;
	connect vehicle.cruiseController.throttlePort to vehicle.engine.throttlePort;
}
