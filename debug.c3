module pleroma::debug;


import pleroma;
import std::io;
import std::core::string;
import std::collections;


struct PlError {
	String text;
	PlErrorLevel level;
	
	int lifespan;
}

enum PlErrorLevel {
	NONE,
	LOW,
	MID,
	HIGH,
	CRITICAL,
}

fault PleromaFault {
	GENERAL_FAILURE,
	BULK_FAILED_FIND_ENTRY,
}

const int LOGTIMER_DEF = 200;

bool debug_state = true;
bool debug_print = true;
List(<PlError*>) error_list;
int log_timer = LOGTIMER_DEF;

/**
 * Log error
 * @param f
 * @param args
 **/
//TODO redo this with arguments
fn void log(PleromaFault f, args...) {
	PlError error = {
		.lifespan = LOGTIMER_DEF,
	};
	
	String text;
	switch (f) {
		//= General
		case PleromaFault.GENERAL_FAILURE:
			error.text = string::tformat("[%s] - %s %s", PlErrorLevel.NONE, "General error.", args);
			error.level = PlErrorLevel.NONE;
		
		//= Bulk
		case PleromaFault.BULK_FAILED_FIND_ENTRY:
			error.text = string::tformat("[%s] - %s %s", PlErrorLevel.LOW, "Failed to find inputted entry in Bulk.", args);
			error.level = PlErrorLevel.LOW;
	}
	
	if (debug_print) { io::printfn(error.text); }
	
	PlError* ptr = (PlError*)malloc($sizeof(error));
	*ptr = error;
	error_list.push(ptr);
}

//= Drawing
/**
 *
 **/
fn void draw_debug_log() {
	List(<int>) values;
	
	
	for (int i = 0; i < error_list.len(); i++) {
		PlError* err = error_list.get(i);
		
		pleroma::draw_text(err.text, 10, pleroma::data.render_size.height - ((i + 1) * 10), 8, color::RED);
		
		err.lifespan--;
		if (err.lifespan <= 0) { error_list.remove_at(i); }
	}
}