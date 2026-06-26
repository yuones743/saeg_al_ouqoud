class Result<T> {
  final T? value;
  final String? error;
  final bool isSuccess;
  const Result.success(this.value) : error = null, isSuccess = true;
  const Result.failure(this.error) : value = null, isSuccess = false;

  R fold<R>({required R Function(T) onSuccess, required R Function(String) onFailure}) {
    return isSuccess ? onSuccess(value as T) : onFailure(error!);
  }
}