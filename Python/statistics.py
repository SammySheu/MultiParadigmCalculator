from typing import List, Optional
from collections import Counter
from dataclasses import dataclass
import json


@dataclass
class ModeResult:
    """
    Data class to represent mode calculation results.

    Using a dataclass demonstrates Python's modern OOP features
    for creating simple, immutable-like data containers.

    Attributes:
        values: List of mode values (supports multimodal data)
        frequency: How many times the mode(s) appear
    """
    values: List[int]
    frequency: int

    def __str__(self) -> str:
        """Returns a formatted string representation of the mode result."""
        if not self.values:
            return "No mode (empty dataset)"
        elif len(self.values) == 1:
            suffix = "" if self.frequency == 1 else "s"
            return f"{self.values[0]} (appears {self.frequency} time{suffix})"
        else:
            return f"{self.values} (each appears {self.frequency} times)"


class StatisticsCalculator:
    """
    A class for calculating statistical measures on a list of integers.

    This class demonstrates object-oriented principles by encapsulating
    data (the integer list) and behavior (statistical calculations)
    within a single cohesive unit.

    Attributes:
        _data: Private list storing the integers (encapsulation)

    Example:
        >>> calc = StatisticsCalculator([1, 2, 3, 4, 5])
        >>> calc.mean
        3.0
        >>> calc.median
        3.0
    """

    def __init__(self, data: Optional[List[int]] = None):
        """
        Initialize the StatisticsCalculator with a list of integers.

        Args:
            data: Optional list of integers. Defaults to empty list.
        """
        self._data: List[int] = list(data) if data else []
        self._sorted_cache: Optional[List[int]] = None

    # =========================================================================
    # PROPERTY ACCESSORS (Encapsulation)
    # =========================================================================

    @property
    def data(self) -> List[int]:
        """
        Get a copy of the data list.

        Returns a copy to prevent external modification of internal state,
        demonstrating encapsulation principles.
        """
        return list(self._data)

    @data.setter
    def data(self, value: List[int]) -> None:
        """
        Set the data list and invalidate cache.

        Args:
            value: New list of integers
        """
        self._data = list(value)
        self._sorted_cache = None

    @property
    def size(self) -> int:
        """Return the number of elements in the dataset."""
        return len(self._data)

    @property
    def is_empty(self) -> bool:
        """Check if the dataset is empty."""
        return len(self._data) == 0

    # =========================================================================
    # PRIVATE HELPER METHODS
    # =========================================================================

    def _get_sorted(self) -> List[int]:
        """
        Get a sorted copy of the data with caching.

        Uses lazy evaluation and caching to avoid repeated sorting,
        demonstrating efficient internal state management.
        """
        if self._sorted_cache is None:
            self._sorted_cache = sorted(self._data)
        return self._sorted_cache

    # =========================================================================
    # STATISTICAL CALCULATION METHODS
    # =========================================================================

    def calculate_mean(self) -> float:
        """
        Calculate the arithmetic mean (average) of the data.

        The mean is computed by summing all elements and dividing
        by the count of elements.

        Returns:
            The mean as a float, or 0.0 for empty dataset.

        Example:
            >>> calc = StatisticsCalculator([2, 4, 6, 8, 10])
            >>> calc.calculate_mean()
            6.0
        """
        if self.is_empty:
            return 0.0
        return sum(self._data) / len(self._data)

    def calculate_median(self) -> float:
        """
        Calculate the median of the data.

        The median is the middle value when the data is sorted.
        For an even number of elements, it's the average of the
        two middle values.

        Returns:
            The median as a float, or 0.0 for empty dataset.

        Example:
            >>> calc = StatisticsCalculator([1, 3, 5, 7, 9])
            >>> calc.calculate_median()
            5.0
        """
        if self.is_empty:
            return 0.0

        sorted_data = self._get_sorted()
        n = len(sorted_data)

        if n % 2 == 1:
            # Odd number of elements: return middle element
            return float(sorted_data[n // 2])
        else:
            # Even number of elements: average of two middle elements
            mid1 = sorted_data[n // 2 - 1]
            mid2 = sorted_data[n // 2]
            return (mid1 + mid2) / 2.0

    def calculate_mode(self) -> ModeResult:
        """
        Calculate the mode(s) of the data.

        The mode is the most frequently occurring value. This method
        handles multimodal data by returning all values that share
        the maximum frequency.

        Uses Python's Counter class from collections module for
        efficient frequency counting.

        Returns:
            ModeResult containing mode values and their frequency.

        Example:
            >>> calc = StatisticsCalculator([1, 2, 2, 3, 3, 3])
            >>> result = calc.calculate_mode()
            >>> result.values
            [3]
            >>> result.frequency
            3
        """
        if self.is_empty:
            return ModeResult(values=[], frequency=0)

        # Use Counter for efficient frequency counting
        frequency_map = Counter(self._data)

        # Find the maximum frequency
        max_frequency = max(frequency_map.values())

        # Collect all values with maximum frequency
        modes = sorted([
            value for value, freq in frequency_map.items()
            if freq == max_frequency
        ])

        return ModeResult(values=modes, frequency=max_frequency)

    # =========================================================================
    # PROPERTY-BASED ACCESSORS (Alternative API)
    # =========================================================================

    @property
    def mean(self) -> float:
        """Property accessor for mean calculation."""
        return self.calculate_mean()

    @property
    def median(self) -> float:
        """Property accessor for median calculation."""
        return self.calculate_median()

    @property
    def mode(self) -> ModeResult:
        """Property accessor for mode calculation."""
        return self.calculate_mode()

    # =========================================================================
    # UTILITY METHODS
    # =========================================================================

    def add_value(self, value: int) -> None:
        """
        Add a single value to the dataset.

        Args:
            value: Integer to add
        """
        self._data.append(value)
        self._sorted_cache = None

    def add_values(self, values: List[int]) -> None:
        """
        Add multiple values to the dataset.

        Args:
            values: List of integers to add
        """
        self._data.extend(values)
        self._sorted_cache = None

    def clear(self) -> None:
        """Clear all data from the calculator."""
        self._data = []
        self._sorted_cache = None

    def get_summary(self) -> dict:
        """
        Get a dictionary containing all statistics.

        Returns:
            Dictionary with keys: 'mean', 'median', 'mode', 'mode_frequency'
        """
        mode_result = self.calculate_mode()
        return {
            'data': self.data,
            'size': self.size,
            'mean': self.calculate_mean(),
            'median': self.calculate_median(),
            'mode': mode_result.values,
            'mode_frequency': mode_result.frequency
        }

    # =========================================================================
    # SPECIAL METHODS (Python OOP Magic Methods)
    # =========================================================================

    def __repr__(self) -> str:
        """Return a detailed string representation for debugging."""
        return f"StatisticsCalculator(data={self._data})"

    def __str__(self) -> str:
        """Return a user-friendly string representation."""
        return f"StatisticsCalculator with {self.size} elements"

    def __len__(self) -> int:
        """Return the number of elements (supports len() function)."""
        return self.size

    def __bool__(self) -> bool:
        """Return True if dataset is not empty."""
        return not self.is_empty


class ExtendedStatisticsCalculator(StatisticsCalculator):
    """
    Extended calculator demonstrating inheritance.

    This subclass adds additional statistical methods to show
    how OOP allows for extension without modification.
    """

    def calculate_range(self) -> int:
        """Calculate the range (max - min) of the data."""
        if self.is_empty:
            return 0
        sorted_data = self._get_sorted()
        return sorted_data[-1] - sorted_data[0]

    def calculate_variance(self) -> float:
        """Calculate the population variance of the data."""
        if self.is_empty:
            return 0.0
        mean = self.calculate_mean()
        squared_diffs = [(x - mean) ** 2 for x in self._data]
        return sum(squared_diffs) / len(self._data)

    def calculate_std_dev(self) -> float:
        """Calculate the population standard deviation."""
        return self.calculate_variance() ** 0.5

    @property
    def range(self) -> int:
        """Property accessor for range calculation."""
        return self.calculate_range()

    @property
    def variance(self) -> float:
        """Property accessor for variance calculation."""
        return self.calculate_variance()

    @property
    def std_dev(self) -> float:
        """Property accessor for standard deviation calculation."""
        return self.calculate_std_dev()


def main() -> None:

    print("This program uses the StatisticsCalculator class to calculate the mean, median, and mode of a dataset.")
    while (dataset := input("Enter a dataset (comma separated. e.g. 1,2,3,4,5): or 'q' to quit): ")) != "q":
        dataset = [int(x) for x in dataset.split(',')]
        calculator = ExtendedStatisticsCalculator(dataset)

        print("\n" + "="*60 + "\n")

        print(f"Data: {calculator.data}")
        print(f"Size: {calculator.size} elements")
        print(f"Mean: {calculator.mean:.2f}")
        print(f"Median: {calculator.median:.2f}")
        print(f"Mode: {calculator.mode}")

        print(f"Summary: {json.dumps(calculator.get_summary(), indent=4)}")

        print(f"Range: {calculator.range:.2f}")
        print(f"Variance: {calculator.variance:.2f}")
        print(f"Standard Deviation: {calculator.std_dev:.2f}")
        print("\n" + "="*60 + "\n")


if __name__ == "__main__":
    main()
