using System.Collections.Specialized;
using System.Text;

namespace referenceApp.Common.Utility
{

    /// <summary>
    /// Class containing static conversion methods.
    /// </summary>
    public class ConversionUtility
    {

        #region String Collection Conversion Methods

        /// <summary>
        /// Converts the provided List collection of integers to a delimited string using 
        /// the optional string parameter as the delimiter. The delimiter default is a comma
        /// with no spaces.
        /// </summary>
        /// <param name="values">List(int) collection containing the values to convert.</param>
        /// <returns>String containing the converted values separated by the delimiter string.</returns>
        public static string IntegerListToString(List<int> values)
        {
            return IntegerListToString(values, ",");
        }

        /// <summary>
        /// Converts the provided List collection of integers to a delimited string using 
        /// the optional string parameter as the delimiter. The delimiter default is a comma
        /// with no spaces.
        /// </summary>
        /// <param name="values">List(int) collection containing the values to convert.</param>
        /// <param name="delimiter">String to use as the delimiter.</param>
        /// <returns>String containing the converted values separated by the delimiter string.</returns>
        public static string IntegerListToString(List<int> values, string delimiter)
        {
            var sb = new StringBuilder(20);
            if (values != null && values.Count > 0)
            {
                foreach (int value in values)
                {
                    if (sb.Length > 0)
                    {
                        sb.Append(delimiter);
                    }
                    sb.Append(value);
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Converts the provided List collection of strings to a delimited string using 
        /// the optional string parameter as the delimiter. The delimiter default is a comma
        /// with no spaces.
        /// </summary>
        /// <param name="values">List(string) collection containing the values to convert.</param>
        /// <param name="delimiter">String to use as the delimiter.</param>
        /// <returns>String containing the converted values separated by the delimiter string.</returns>
        public static string StringListToString(List<string> values, string delimiter = ", ")
        {
            var sb = new StringBuilder(100);
            if (values != null && values.Count > 0)
            {
                foreach (string value in values)
                {
                    if (sb.Length > 0)
                    {
                        sb.Append(delimiter);
                    }
                    sb.Append(value);
                }
            }
            return sb.ToString();
        }

        /// <summary>
        /// Converts the provided comma delimited string to a List collection of integer 
        /// values. Any items that can't be converted to integer are excluded from the return list.
        /// </summary>
        /// <param name="value">Comma delimited string of values to convert.</param>
        /// <returns>List(int) collection of converted values.</returns>
        public static List<int> StringToIntegerList(string value)
        {
            if (!string.IsNullOrEmpty(value))
            {
                return StringListToIntegerList(value.Split(",".ToCharArray()).ToList());
            }
            else
            {
                return new List<int>();
            }
        }

        /// <summary>
        /// Converts the provided List collection of string values to a List collection of integer 
        /// values. Any items that can't be converted to integer are excluded from the return list.
        /// </summary>
        /// <param name="values">List(string) collection of values to convert.</param>
        /// <returns>List(int) collection of converted values.</returns>
        public static List<int> StringListToIntegerList(List<string> values)
        {
            var result = new List<int>();
            if (values.Count > 0)
            {
                foreach (string value in values)
                {
                    if (int.TryParse(value, out var number))
                    {
                        result.Add(number);
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Converts the provided comma delimited string to a StringCollection of string 
        /// values. 
        /// </summary>
        /// <param name="value">Comma delimited string of values to convert.</param>
        /// <returns>String collection of converted values.</returns>
        public static StringCollection StringToStringCollection(string value)
        {
            var results = new StringCollection();
            if (!string.IsNullOrEmpty(value))
            {
                results.AddRange(value.Split(",".ToCharArray()).ToArray());
            }
            return results;
        }

        #endregion

        
    }
}
