# Notes & Thoughts

2015-08-30
* Initial commit of source files.
* The code in the files is **far** from optimal. You can tell that the code and design became more sophisticated and refined as I progressed through the assignment's parts. The hints and tutorial for the assignment aided in the gradual elaboration of the code and ideas about working with data.
* I think one of key points--if not **the** key point--of this assignment is how to think about and work with data. I initially started by trying to just get the minimum-scoring row of part of a dataset. But the tutorial for the assignment repeatedly used sorting and indexing throughout its approaches. While that approach wasn't crucial for the first part of the assignment, it became crucial for the second and third parts. It also challanged my desire to prematurely optimize code and reduce memory footprint of the data--my priority shifted to clearer and more process-oriented code which helped make the solutions more flexible.
* The instructions for the assignment hinder some improvements on the design and code, but I think improvements can be made.
* Ideas about improvements:
  * Redo the simple caching of the dataset. It currently uses a global variable, but I think some of the object-oriented ideas from the second assignment and experiments with closures could be used instead.
  * Separate the helper functions out into a dedicated utilities file sourced into each function file.
  * Create get.best(), get.worst(), and get.rank() helper functions.
  * Factor out the primary functions' code commonalities into more helper functions.
  * While the primary functions may not be shareable, the code files themselves may be able to be cascaded similar to how I have them now (but hopefully better refined).
  * Remember that these are scripts and not overly-structured, compiled source files (e.g. C and its required main() function). Use that to better advantage in code and design.
  * Revisit the processes of rankall()--look for ways to simplify and focus the subtasks of the function and how it acts on the data.
  
