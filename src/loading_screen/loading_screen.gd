class_name LoadingScreen
extends CanvasLayer

signal loading_complete

@onready var _progress_bar: ProgressBar = %ProgressBar
@onready var _spinner: ColorRect = %Spinner

const SPIN_SPEED: float = TAU  # one full rotation per second
const MIN_DURATION: float = 5.0

var _pending: Array[String] = []
var _total: int = 0
var _elapsed: float = 0.0
var _resources_done: bool = false

func _ready() -> void:
	_progress_bar.show_percentage = false
	_progress_bar.min_value = 0.0
	_progress_bar.max_value = 1.0
	_progress_bar.value = 0.0

	_spinner.pivot_offset = _spinner.size / 2.0

func start(paths: Array[String]) -> void:
	_total = paths.size()
	_pending = paths.duplicate()
	for path in paths:
		ResourceLoader.load_threaded_request(path)

func _process(delta: float) -> void:
	_elapsed += delta
	_spinner.rotation += SPIN_SPEED * delta

	_progress_bar.value = minf(_elapsed / MIN_DURATION, 1.0)

	if not _resources_done:
		var completed: Array[String] = []
		for path in _pending:
			var status := ResourceLoader.load_threaded_get_status(path)
			match status:
				ResourceLoader.THREAD_LOAD_LOADED, ResourceLoader.THREAD_LOAD_FAILED:
					if status == ResourceLoader.THREAD_LOAD_FAILED:
						push_error("LoadingScreen: failed to load %s" % path)
					completed.append(path)
		for path in completed:
			_pending.erase(path)
		if _pending.is_empty():
			_resources_done = true

	if _resources_done and _elapsed >= MIN_DURATION:
		_progress_bar.value = 1.0
		loading_complete.emit()
